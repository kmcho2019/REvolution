module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

// Define the states
parameter A = 1'b0;
parameter B = 1'b1;

// Define the current state
reg current_state;
initial current_state = B;

// Next state logic
always @(posedge clk or posedge reset) begin
    if(reset) begin
        current_state <= B;
    end else begin
        case(current_state)
            B: begin
                if(!in) begin
                    current_state <= A;
                end else begin
                    current_state <= B;
                end
            end
            A: begin
                if(!in) begin
                    current_state <= B;
                end else begin
                    current_state <= A;
                end
            end
            default: begin
                current_state <= B;
            end
        endcase
    end
end

// Output logic
always @(*) begin
    case(current_state)
        B: out = 1'b1;
        A: out = 1'b0;
        default: out = 1'b1;
    endcase
end

endmodule