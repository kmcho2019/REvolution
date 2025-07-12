module TopModule (
    input  clk,
    input  reset,
    input  w,
    output z
);

// Define the states
parameter A = 4'd0;
parameter B = 4'd1;
parameter C = 4'd2;
parameter D = 4'd3;
parameter E = 4'd4;
parameter F = 4'd5;

// Define the current state and next state
reg [3:0] current_state;
reg [3:0] next_state;

// Sequential logic to update the current state
always @ (posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= A;
    end else begin
        current_state <= next_state;
    end
end

// Combinational logic to determine the next state
always @ (*) begin
    case (current_state)
        A: begin
            if (w) begin
                next_state = A;
            end else begin
                next_state = B;
            end
        end
        B: begin
            if (w) begin
                next_state = D;
            end else begin
                next_state = C;
            end
        end
        C: begin
            if (w) begin
                next_state = D;
            end else begin
                next_state = E;
            end
        end
        D: begin
            if (w) begin
                next_state = A;
            end else begin
                next_state = F;
            end
        end
        E: begin
            if (w) begin
                next_state = D;
            end else begin
                next_state = E;
            end
        end
        F: begin
            if (w) begin
                next_state = D;
            end else begin
                next_state = C;
            end
        end
        default: begin
            next_state = A;
        end
    endcase
end

// Combinational logic to determine the output
always @ (*) begin
    case (current_state)
        A: z = 1'b0;
        B: z = 1'b0;
        C: z = 1'b0;
        D: z = 1'b0;
        E: z = 1'b1;
        F: z = 1'b1;
        default: z = 1'b0;
    endcase
end

endmodule