module TopModule (
    input clk,
    input reset,
    input [7:0] in,
    output done
);

    // State encoding
    localparam IDLE = 2'b00;
    localparam BYTE1 = 2'b01;
    localparam BYTE2 = 2'b10;
    localparam BYTE3 = 2'b11;

    reg [1:0] state;

    // Next state assignments (combinational)
    wire [1:0] next_state;
    assign next_state = (state == IDLE)  ? (in[3] ? BYTE1 : IDLE) :
                       (state == BYTE1) ? BYTE2 :
                       (state == BYTE2) ? BYTE3 :
                       (state == BYTE3) ? (in[3] ? BYTE1 : IDLE) : IDLE;

    // State register (sequential)
    always @(posedge clk) begin
        if (reset)
            state <= IDLE;
        else
            state <= next_state;
    end

    // Output assignment (combinational)
    assign done = (state == BYTE3);

endmodule