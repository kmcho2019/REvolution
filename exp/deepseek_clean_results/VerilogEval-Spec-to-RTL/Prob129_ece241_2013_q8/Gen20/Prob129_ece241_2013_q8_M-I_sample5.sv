module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

    // One-hot encoded states
    reg [2:0] state;
    localparam IDLE  = 3'b001;
    localparam GOT1  = 3'b010;
    localparam GOT10 = 3'b100;

    always @(posedge clk or negedge aresetn) begin
        if (!aresetn) begin
            state <= IDLE;
        end
        else if (x != state[0]) begin  // Only update state if input changes
            case (state)
                IDLE:  state <= x ? GOT1 : IDLE;
                GOT1:  state <= x ? GOT1 : GOT10;
                GOT10: state <= x ? GOT1 : IDLE;
                default: state <= IDLE;
            endcase
        end
    end

    assign z = (state == GOT10) & x;  // Simplified output logic

endmodule