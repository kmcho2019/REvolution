module TopModule (
    input clk,
    input areset,
    input x,
    output z
);

    reg state;
    localparam IDLE = 1'b0;
    localparam COMPLEMENT = 1'b1;
    
    always @(posedge clk or posedge areset) begin
        if (areset) begin
            state <= IDLE;
        end
        else begin
            case (state)
                IDLE: if (x) state <= COMPLEMENT;
                COMPLEMENT: state <= COMPLEMENT;
            endcase
        end
    end

    assign z = (state == IDLE) ? x : ~x;

endmodule