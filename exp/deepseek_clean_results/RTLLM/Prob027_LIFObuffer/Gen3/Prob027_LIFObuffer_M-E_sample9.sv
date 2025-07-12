module LIFObuffer (
    input wire [3:0] dataIn,
    input wire RW,
    input wire EN,
    input wire Rst,
    input wire Clk,
    output wire EMPTY,
    output wire FULL,
    output reg [3:0] dataOut
);

    reg [3:0] buffer [0:3];  // Circular buffer memory
    reg [1:0] head, tail;    // 2-bit pointers (0-3)
    reg [1:0] count;         // Entry count (0-4)

    // Combinational flag logic
    assign EMPTY = (count == 0);
    assign FULL = (count == 4);

    always @(posedge Clk) begin
        if (Rst) begin
            // Reset initialization
            head <= 0;
            tail <= 0;
            count <= 0;
            dataOut <= 0;
        end
        else if (EN) begin
            if (!RW && !FULL) begin  // Write operation
                buffer[head] <= dataIn;
                head <= head + 1;
                count <= count + 1;
            end
            else if (RW && !EMPTY) begin  // Read operation
                // Calculate last written position (head-1 mod 4)
                dataOut <= buffer[(head == 0) ? 3 : head - 1];
                head <= (head == 0) ? 3 : head - 1;
                count <= count - 1;
            end
        end
    end

endmodule