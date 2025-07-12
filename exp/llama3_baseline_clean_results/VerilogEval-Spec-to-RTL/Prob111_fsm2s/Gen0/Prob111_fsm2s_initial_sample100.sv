`define OFF 2'b00
`define ON  2'b01

module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

reg [1:0] state, next_state;
assign out = (state == `ON) ? 1'b1 : 1'b0;

always_ff @(posedge clk) begin
    if(reset) begin
        state <= `OFF;
    end else begin
        state <= next_state;
    end
end

always_comb begin
    case(state)
        `OFF: begin
            if(j) begin
                next_state = `ON;
            end else begin
                next_state = `OFF;
            end
        end
        `ON: begin
            if(k) begin
                next_state = `OFF;
            end else begin
                next_state = `ON;
            end
        end
        default: next_state = `OFF;
    endcase
end

endmodule