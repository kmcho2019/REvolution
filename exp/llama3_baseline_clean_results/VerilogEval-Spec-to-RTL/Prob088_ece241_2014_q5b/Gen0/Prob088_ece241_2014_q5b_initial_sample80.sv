module TopModule(
    input  clk,
    input  areset,
    input  x,
    output z
);

reg [1:0] state, next_state;
wire [1:0] state_w;
assign state_w = state;

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 2'b10; // Reset to state A
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case(state_w)
        2'b10: begin // State A
            if(x == 1'b0) begin
                next_state = 2'b10;
                z = 1'b0;
            end else begin
                next_state = 2'b01;
                z = 1'b1;
            end
        end
        2'b01: begin // State B
            next_state = 2'b01;
            if(x == 1'b0) begin
                z = 1'b1;
            end else begin
                z = 1'b0;
            end
        end
        default: begin
            next_state = 2'b10; // Default to state A
            z = 1'b0;
        end
    endcase
end

endmodule