module LIFObuffer (
    input [3:0] dataIn,
    input RW,
    input EN,
    input Rst,
    input Clk,
    output reg EMPTY,
    output reg FULL,
    output reg [3:0] dataOut
);

    reg [3:0] buffer [0:3];  // 4-entry circular buffer
    reg [2:0] head;         // Points to next write location
    reg [2:0] tail;         // Follows head for read operations

    wire head_plus_1 = (head == 3'd3) ? 3'd0 : head + 1;
    wire head_minus_1 = (head == 3'd0) ? 3'd3 : head - 1;

    always @(posedge Clk) begin
        if (Rst) begin
            // Initialize pointers and flags
            head <= 3'd0;
            tail <= 3'd0;
            EMPTY <= 1'b1;
            FULL <= 1'b0;
            dataOut <= 4'b0;
            // Clear buffer
            buffer[0] <= 4'b0;
            buffer[1] <= 4'b0;
            buffer[2] <= 4'b0;
            buffer[3] <= 4'b0;
        end
        else if (EN) begin
            if (!RW && !FULL) begin
                // Write operation (push)
                buffer[head] <= dataIn;
                head <= head_plus_1;
            end
            else if (RW && !EMPTY) begin
                // Read operation (pop)
                dataOut <= buffer[head_minus_1];
                head <= head_minus_1;
            end

            // Update flags
            EMPTY <= (head == tail);
            FULL <= (head_plus_1 == tail);
        end
    end

endmodule