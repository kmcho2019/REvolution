module TopModule(
    input  clk,
    input  reset,
    input  w,
    output z
);

// Define state codes
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b011;
parameter E = 3'b100;
parameter F = 3'b101;

// Current state register
reg [2:0] current_state;

// Next state logic
always @(*) begin
    case(current_state)
        A: begin
            if(w)
                current_state <= B;
            else
                current_state <= A;
        end
        B: begin
            if(w)
                current_state <= C;
            else
                current_state <= D;
        end
        C: begin
            if(w)
                current_state <= E;
            else
                current_state <= D;
        end
        D: begin
            if(w)
                current_state <= F;
            else
                current_state <= A;
        end
        E: begin
            if(w)
                current_state <= E;
            else
                current_state <= D;
        end
        F: begin
            if(w)
                current_state <= C;
            else
                current_state <= D;
        end
        default: current_state <= A;
    endcase
end

// State flip-flops
always @(posedge clk) begin
    if(reset)
        current_state <= A;
    else
        // Do nothing, next state is already calculated in always @(*)
end

// Output logic
assign z = (current_state == E || current_state == F);

endmodule