module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

reg [2:0] state;
reg [2:0] next_state;

always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= 3'b000; // reset to state A
    end else begin
        state <= next_state;
    end
end

always @(*) begin
    case(state)
        3'b000: // A
            if(w == 1'b1) begin
                next_state = 3'b000; // stay in A
            end else begin
                next_state = 3'b001; // go to B
            end
        3'b001: // B
            if(w == 1'b1) begin
                next_state = 3'b011; // go to D
            end else begin
                next_state = 3'b010; // go to C
            end
        3'b010: // C
            if(w == 1'b1) begin
                next_state = 3'b011; // go to D
            end else begin
                next_state = 3'b100; // go to E
            end
        3'b011: // D
            if(w == 1'b1) begin
                next_state = 3'b000; // go to A
            end else begin
                next_state = 3'b101; // go to F
            end
        3'b100: // E
            if(w == 1'b1) begin
                next_state = 3'b011; // go to D
            end else begin
                next_state = 3'b100; // stay in E
            end
        3'b101: // F
            if(w == 1'b1) begin
                next_state = 3'b011; // go to D
            end else begin
                next_state = 3'b010; // go to C
            end
        default: next_state = 3'b000; // default to state A
    endcase
end

assign z = (state == 3'b100) || (state == 3'b101); // output 'z' is 1 when state is E or F

endmodule