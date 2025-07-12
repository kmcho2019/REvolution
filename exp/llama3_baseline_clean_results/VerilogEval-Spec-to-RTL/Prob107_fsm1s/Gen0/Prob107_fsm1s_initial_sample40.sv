module TopModule(
    input  clk,
    input  reset,
    input  in,
    output out
);

// Define the states
parameter A = 1'b0;
parameter B = 1'b1;

// Current state and next state
reg current_state;
reg next_state;

// Initialize the output based on the current state
always @(*)
begin
    case(current_state)
        A: out = 1'b0;
        B: out = 1'b1;
        default: out = 1'b0;
    endcase
end

// State transition logic
always @(posedge clk)
begin
    if(reset) begin
        current_state <= B;
    end else begin
        case(current_state)
            A: 
            begin
                if(in == 1'b0) begin
                    current_state <= B;
                end else begin
                    current_state <= A;
                end
            end
            B: 
            begin
                if(in == 1'b0) begin
                    current_state <= A;
                end else begin
                    current_state <= B;
                end
            end
            default: current_state <= B;
        endcase
    end
end

endmodule