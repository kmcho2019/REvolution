module TopModule(
    input  clk,
    input  areset,
    input  x,
    output z
);

reg [1:0] state;
reg [1:0] next_state;

always @(areset or state or x) begin
    case(state)
        2'b01: begin // State A
            if(x == 1'b0) begin
                next_state = 2'b01;
                z = 1'b0;
            end else begin
                next_state = 2'b10;
                z = 1'b1;
            end
        end
        2'b10: begin // State B
            if(x == 1'b0) begin
                next_state = 2'b10;
                z = 1'b1;
            end else begin
                next_state = 2'b10;
                z = 1'b0;
            end
        end
        default: begin
            next_state = 2'b01; // Default state is A
            z = 1'b0;
        end
    endcase
end

always @(posedge clk or posedge areset) begin
    if(areset) begin
        state <= 2'b01; // Reset into state A
    end else begin
        state <= next_state;
    end
end

endmodule