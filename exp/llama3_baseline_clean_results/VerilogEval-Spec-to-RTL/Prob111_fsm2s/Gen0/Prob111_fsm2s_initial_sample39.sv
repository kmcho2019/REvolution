module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

// Define states
enum logic [0:0] {OFF, ON} state, next_state;

// State register
always_ff @(posedge clk or posedge reset) begin
    if (reset) begin
        state <= OFF;
    end else begin
        state <= next_state;
    end
end

// Next state logic and output logic
always_comb begin
    case (state)
        OFF: begin
            if (j) begin
                next_state = ON;
            end else begin
                next_state = OFF;
            end
        end
        ON: begin
            if (k) begin
                next_state = OFF;
            end else begin
                next_state = ON;
            end
        end
    endcase
    
    case (state)
        OFF: out = 0;
        ON:  out = 1;
    endcase
end

endmodule