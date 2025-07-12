module TopModule(
    input clock,
    input a,
    output reg p,
    output reg q
);

reg [1:0] state = 0; // Initial state

always @(posedge clock or negedge clock) begin
    case (state)
        2'b00: begin
            if (clock && a) begin
                state <= 2'b01;
            end else if (!clock && a) begin
                state <= 2'b10;
            end else begin
                state <= 2'b00;
            end
        end
        2'b01: begin
            if (clock && a) begin
                state <= 2'b01;
            end else if (!clock) begin
                state <= 2'b10;
            end else begin
                state <= 2'b00;
            end
        end
        2'b10: begin
            if (clock && a) begin
                state <= 2'b01;
            end else if (!clock) begin
                state <= 2'b10;
            end else begin
                state <= 2'b00;
            end
        end
        default: begin
            state <= 2'b00;
        end
    endcase
end

assign p = (clock && a);
assign q = (state == 2'b01 || (state == 2'b10 &&!clock));

endmodule