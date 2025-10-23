module TopModule (
    input clk,
    input resetn,
    input [2:0] r,
    output reg [2:0] g
);

    // One-hot state encoding
    localparam A = 4'b0001;
    localparam B = 4'b0010;
    localparam C = 4'b0100;
    localparam D = 4'b1000;
    
    reg [3:0] state, next_state;

    // State transition logic
    always @(*) begin
        next_state = state; // Default: stay in current state
        
        case (1'b1) // synthesis parallel_case
            state[A]: begin
                if (r[0]) next_state = B;
                else if (r[1]) next_state = C;
                else if (r[2]) next_state = D;
            end
            state[B]: next_state = r[0] ? B : A;
            state[C]: next_state = r[1] ? C : A;
            state[D]: next_state = r[2] ? D : A;
        endcase
    end

    // State register with change detection
    always @(posedge clk) begin
        if (!resetn) begin
            state <= A;
            g <= 3'b000;
        end
        else if (next_state != state) begin
            state <= next_state;
            // Output register update
            g <= {next_state[D], next_state[C], next_state[B]};
        end
    end

endmodule