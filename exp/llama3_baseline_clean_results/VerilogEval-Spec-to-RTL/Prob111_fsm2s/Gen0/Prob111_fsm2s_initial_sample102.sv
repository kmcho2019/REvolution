module TopModule(
    input  clk,
    input  reset,
    input  j,
    input  k,
    output out
);

// Define states
reg [0:0] state;
reg [0:0] next_state;

// Define states as enum
localparam OFF = 1'b0;
localparam ON  = 1'b1;

// Output logic
always @(state) begin
    case(state)
        OFF: out <= 1'b0;
        ON:  out <= 1'b1;
        default: out <= 1'b0;
    endcase
end

// Next state logic
always @(state, j, k, reset) begin
    if(reset) begin
        next_state = OFF;
    end else begin
        case(state)
            OFF: begin
                if(j) begin
                    next_state = ON;
                end else begin
                    next_state = OFF;
                end
            end
            ON: begin
                if(k) begin
                    next_state = OFF;
                end else begin
                    next_state = ON;
                end
            end
            default: next_state = OFF;
        endcase
    end
end

// State register
always @(posedge clk) begin
    if(reset) begin
        state <= OFF;
    end else begin
        state <= next_state;
    end
end

endmodule