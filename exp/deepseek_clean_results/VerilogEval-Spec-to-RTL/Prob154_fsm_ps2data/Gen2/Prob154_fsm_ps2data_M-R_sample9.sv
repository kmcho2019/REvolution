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
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE:   state <= in[3] ? BYTE1 : IDLE;
                BYTE1: state <= BYTE2;
                BYTE2: state <= IDLE;
                default: state <= IDLE;
            endcase
        end
    end

    // Store received bytes
    always @(posedge clk) begin
        if (!reset) begin
            case (state)
                IDLE:   if (in[3]) stored_bytes[15:8] <= in;
                BYTE1:  stored_bytes[7:0] <= in;
                default: ;
            endcase
        end
    end

    // Output assignments
    assign done = (state == BYTE2);
    assign out_bytes = done ? {stored_bytes, in} : 24'b0;

endmodule