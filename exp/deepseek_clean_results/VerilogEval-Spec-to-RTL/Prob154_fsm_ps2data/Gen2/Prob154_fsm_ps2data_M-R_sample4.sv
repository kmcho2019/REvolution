module TopModule(
    input clk,
    input reset,
    input [7:0] in,
    output [23:0] out_bytes,
    output done
);

    // One-hot encoded states
    localparam IDLE = 3'b001;
    localparam BYTE1 = 3'b010;
    localparam BYTE2 = 3'b100;

    reg [2:0] state;
    reg [15:0] stored_bytes; // Stores first two bytes

    // Next state logic
    wire next_IDLE = (state == BYTE2) || (state == IDLE && !in[3]);
    wire next_BYTE1 = (state == IDLE && in[3]) || (state == BYTE2);
    wire next_BYTE2 = (state == BYTE1);

    // State transition
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
            stored_bytes <= 16'b0;
        end else begin
            state <= {next_BYTE2, next_BYTE1, next_IDLE};
            
            // Store bytes when appropriate
            if (state == IDLE && in[3])
                stored_bytes[15:8] <= in;
            else if (state == BYTE1)
                stored_bytes[7:0] <= in;
        end
    end

    // Output logic
    assign done = (state == BYTE2);
    assign out_bytes = done ? {stored_bytes, in} : 24'b0;

endmodule