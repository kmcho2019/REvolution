module TopModule (
    input clk,
    input aresetn,
    input x,
    output z
);

reg [1:0] state;
reg [1:0] next_state;
assign z = (state == 2'b10 && x == 1'b1);

always @(posedge clk or negedge aresetn) begin
    if (~aresetn) begin
        state <= 2'b00;
    end else begin
        case (state)
            2'b00: begin
                if (x == 1'b1) begin
                    state <= 2'b01;
                end else begin
                    state <= 2'b00;
                end
            end
            2'b01: begin
                if (x == 1'b0) begin
                    state <= 2'b10;
                end else begin
                    state <= 2'b01;
                end
            end
            2'b10: begin
                if (x == 1'b1) begin
                    state <= 2'b01;
                end else begin
                    state <= 2'b00;
                end
            end
            default: begin
                state <= 2'b00;
            end
        endcase
    end
end

endmodule