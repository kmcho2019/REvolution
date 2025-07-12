module TopModule(
    input clk,
    input x,
    input [2:0] y,
    output Y0,
    output z
);

reg [2:0] curr_state;
reg [2:0] next_state;

always @(*) begin
    case (curr_state)
        3'b000: begin
            if (!x) next_state = 3'b000;
            else next_state = 3'b001;
        end
        3'b001: begin
            if (!x) next_state = 3'b001;
            else next_state = 3'b100;
        end
        3'b010: begin
            if (!x) next_state = 3'b010;
            else next_state = 3'b001;
        end
        3'b011: begin
            if (!x) next_state = 3'b001;
            else next_state = 3'b010;
        end
        3'b100: begin
            if (!x) next_state = 3'b011;
            else next_state = 3'b100;
        end
        default: next_state = 3'b000;
    endcase
    
    if (curr_state == 3'b011 || curr_state == 3'b100) begin
        z = 1'b1;
    end else begin
        z = 1'b0;
    end
end

always @ (posedge clk) begin
    curr_state <= next_state;
    Y0 <= next_state[0];
end

initial begin
    curr_state = 3'b000;
end

endmodule