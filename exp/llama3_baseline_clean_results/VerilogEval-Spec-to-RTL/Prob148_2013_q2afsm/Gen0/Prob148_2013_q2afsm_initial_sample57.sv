module TopModule(
    input  clk,
    input  resetn,
    input  [2:0] r,
    output [2:0] g
);

// Define the state codes
parameter A = 4'b0000;
parameter B = 4'b0001;
parameter C = 4'b0010;

// Declare the current and next states
reg [3:0] current_state;
reg [3:0] next_state;

// State flip-flops
always @(posedge clk) begin
    if (!resetn) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

// State table
always @(*) begin
    case (current_state)
        A: begin
            if (r[0] == 1'b1) begin
                next_state <= B;
            end else if (r[1] == 1'b1) begin
                next_state <= C;
            end else if (r[2] == 1'b1) begin
                next_state <= C; // Since C is the only other state with a grant, use it for device 2 as well
            end else begin
                next_state <= A;
            end
        end
        B: begin
            if (r[0] == 1'b1) begin
                next_state <= B;
            end else begin
                next_state <= A;
            end
        end
        C: begin
            if (r[1] == 1'b1) begin
                next_state <= C;
            end else begin
                next_state <= A;
            end
        end
        default: next_state <= A;
    endcase
end

// Determine the outputs g[i] based on the current state
always @(*) begin
    case (current_state)
        A: begin
            g <= 3'b000;
        end
        B: begin
            g <= 3'b100;
        end
        C: begin
            g <= 3'b010;
        end
        default: g <= 3'b000;
    endcase
end

endmodule