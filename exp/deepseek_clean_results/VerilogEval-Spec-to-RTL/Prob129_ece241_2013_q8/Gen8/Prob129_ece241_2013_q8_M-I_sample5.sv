module TopModule (
    input clk,
    input aresetn,
    input x,
    output reg z
);

    // One-hot encoded states
    reg [2:0] state;
    localparam IDLE  = 3'b001;
    localparam GOT1  = 3'b010;
    localparam GOT10 = 3'b100;

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= IDLE;
            z <= 1'b0;
        end else begin
            case (state)
                IDLE: begin
                    state <= x ? GOT1 : IDLE;
                    z <= 1'b0;
                end
                GOT1: begin
                    state <= x ? GOT1 : GOT10;
                    z <= 1'b0;
                end
                GOT10: begin
                    state <= x ? GOT1 : IDLE;
                    z <= x;  // Mealy output
                end
                default: state <= IDLE;
            endcase
        end
    end

endmodule