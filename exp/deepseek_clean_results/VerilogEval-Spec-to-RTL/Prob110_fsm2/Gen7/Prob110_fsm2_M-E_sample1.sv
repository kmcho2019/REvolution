module TopModule (
    input clk,
    input areset,
    input j,
    input k,
    output out
);
    reg state;
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= 1'b0;
        end else begin
            case (state)
                1'b0: state <= j ? ~state : state;
                1'b1: state <= k ? ~state : state;
            endcase
        end
    end
    
    assign out = state;
endmodule