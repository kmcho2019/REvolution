module TopModule(
    input       clk,
    input       reset,
    input       w,
    output      z
);

// Define states
parameter   A = 2'b00,
            B = 2'b01,
            C = 2'b10,
            D = 2'b11,
            E = 2'b100,
            F = 2'b101;

// Define state variable
reg [3:0]   state;
reg [3:0]   next_state;

// State flip-flops
always @(posedge clk) begin
    if (reset) begin
        state <= A;
    end else begin
        state <= next_state;
    end
end

// State table
always @(*) begin
    case (state)
        A: begin
            if (w) begin
                next_state = B;
            end else begin
                next_state = A;
            end
        end
        B: begin
            if (w) begin
                next_state = C;
            end else begin
                next_state = D;
            end
        end
        C: begin
            if (w) begin
                next_state = E;
            end else begin
                next_state = D;
            end
        end
        D: begin
            if (w) begin
                next_state = F;
            end else begin
                next_state = A;
            end
        end
        E: begin
            if (w) begin
                next_state = E;
            end else begin
                next_state = D;
            end
        end
        F: begin
            if (w) begin
                next_state = C;
            end else begin
                next_state = D;
            end
        end
        default: next_state = A;
    endcase
end

// Output z
assign z = (state == E) | (state == F);

endmodule