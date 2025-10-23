module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output [2:0] g
);

    // State encoding with descriptive names
    localparam [1:0] IDLE  = 2'b00,
                     GRANT0 = 2'b01,
                     GRANT1 = 2'b10,
                     GRANT2 = 2'b11;

    reg [1:0] state;

    // State register with synchronous reset
    always @(posedge clk) begin
        if (!resetn)
            state <= IDLE;
        else case (state)
            IDLE:  state <= r[0] ? GRANT0 : r[1] ? GRANT1 : r[2] ? GRANT2 : IDLE;
            GRANT0: state <= r[0] ? GRANT0 : IDLE;
            GRANT1: state <= r[1] ? GRANT1 : IDLE;
            GRANT2: state <= r[2] ? GRANT2 : IDLE;
        endcase
    end

    // Optimized output logic - single decoder
    assign g = (state == GRANT0) ? 3'b001 :
               (state == GRANT1) ? 3'b010 :
               (state == GRANT2) ? 3'b100 : 3'b000;

endmodule