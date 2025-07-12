module TopModule(
    input clk,
    input areset,
    input x,
    output z
);

reg detector;
reg [1:0] state;

always @(posedge clk or posedge areset) begin
    if (areset) begin
        detector <= 0;
        state <= 0;
    end else begin
        case (state)
            0: begin
                if (x) begin
                    state <= 1;
                    detector <= 1;
                end
            end
            1: begin
                state <= 1;
            end
            default: state <= 0;
        endcase
    end
end

assign z = (detector)? ~x : x;

endmodule