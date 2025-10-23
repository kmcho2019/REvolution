module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

// Define states
parameter B = 1'b0, A = 1'b1;

// Register to hold the current state
reg current_state;

// Output based on the current state
assign out = (current_state == B) ? 1'b1 : 1'b0;

// Sequential logic to update the state
always @ (posedge clk) begin
    if(reset) begin
        current_state <= B;
    end else begin
        case(current_state)
            B: begin
                if(!in) begin
                    current_state <= A;
                end
            end
            A: begin
                if(!in) begin
                    current_state <= B;
                end
            end
            default: current_state <= B;
        endcase
    end
end

endmodule