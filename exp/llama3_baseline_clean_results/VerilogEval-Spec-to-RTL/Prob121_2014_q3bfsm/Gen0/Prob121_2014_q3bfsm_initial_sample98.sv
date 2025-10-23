module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

// Define states
parameter [2:0] S000 = 3'b000;
parameter [2:0] S001 = 3'b001;
parameter [2:0] S010 = 3'b010;
parameter [2:0] S011 = 3'b011;
parameter [2:0] S100 = 3'b100;

reg [2:0] state, next_state;

// Sequential logic
always @(posedge clk) begin
    if(reset) begin
        state <= S000;
    end else begin
        state <= next_state;
    end
end

// Combinational logic
always @(*) begin
    case(state)
        S000: begin
            if(!x) next_state <= S000;
            else next_state <= S001;
            z <= 0;
        end
        S001: begin
            if(!x) next_state <= S001;
            else next_state <= S100;
            z <= 0;
        end
        S010: begin
            if(!x) next_state <= S010;
            else next_state <= S001;
            z <= 0;
        end
        S011: begin
            if(!x) next_state <= S001;
            else next_state <= S010;
            z <= 1;
        end
        S100: begin
            if(!x) next_state <= S011;
            else next_state <= S100;
            z <= 1;
        end
        default: begin
            next_state <= S000;
            z <= 0;
        end
    endcase
end

endmodule