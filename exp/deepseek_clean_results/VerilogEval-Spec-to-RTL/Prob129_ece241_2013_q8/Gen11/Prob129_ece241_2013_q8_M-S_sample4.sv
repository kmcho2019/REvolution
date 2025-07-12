module TopModule (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    reg [1:0] state;

    localparam IDLE  = 2'b00;
    localparam GOT1  = 2'b01;
    localparam GOT10 = 2'b10;

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= IDLE;
            z <= 1'b0;
        end else begin
            case (state)
                IDLE:  state <= x ? GOT1 : IDLE;
                GOT1:  state <= x ? GOT1 : GOT10;
                GOT10: state <= x ? GOT1 : IDLE;
            endcase
            z <= (state == GOT10) & x;
        end
    end

endmodule