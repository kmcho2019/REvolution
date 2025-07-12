module TopModule(
    input clk,
    input areset,
    input in,
    output out
);

// Define the states
parameter A = 2'b00;
parameter B = 2'b01;
parameter C = 2'b10;
parameter D = 2'b11;

// Define the current state and next state
reg [1:0] current_state;
reg [1:0] next_state;

// Define the output
reg out_reg;

// Combinational always block to determine the next state and output
always @(*) begin
    case (current_state)
        A: begin
            if (!in) begin
                next_state = A;
            end else begin
                next_state = B;
            end
            out_reg = 0;
        end
        B: begin
            if (!in) begin
                next_state = C;
            end else begin
                next_state = B;
            end
            out_reg = 0;
        end
        C: begin
            if (!in) begin
                next_state = A;
            end else begin
                next_state = D;
            end
            out_reg = 0;
        end
        D: begin
            if (!in) begin
                next_state = C;
            end else begin
                next_state = B;
            end
            out_reg = 1;
        end
        default: begin
            next_state = A;
            out_reg = 0;
        end
    endcase
end

// Sequential always block to update the current state
always @(posedge clk or posedge areset) begin
    if (areset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

// Continuous assignment to output
assign out = out_reg;

endmodule