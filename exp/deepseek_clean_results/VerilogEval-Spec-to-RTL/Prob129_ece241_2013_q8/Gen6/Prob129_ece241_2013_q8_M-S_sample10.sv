module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    reg [1:0] state;

    localparam IDLE  = 2'b00;
    localparam GOT1  = 2'b01;
    localparam GOT10 = 2'b10;

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= IDLE;
        end else begin
            case (state)
                IDLE:  state <= x ? GOT1 : IDLE;
                GOT1:  state <= x ? GOT1 : GOT10;
                GOT10: state <= x ? GOT1 : IDLE;
                default: state <= IDLE;
            endcase
        end
    end

    assign z = (state == GOT10) & x;

endmodule