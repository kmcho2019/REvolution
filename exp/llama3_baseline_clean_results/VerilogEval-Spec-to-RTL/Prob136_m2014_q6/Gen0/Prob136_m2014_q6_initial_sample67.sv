module TopModule (
    input  clk,
    input  reset,
    input  w,
    output z
);

reg [2:0] state;  // Current state
reg [2:0] next_state;  // Next state
reg z_reg;  // Output register

// Define the states
localparam A = 3'b000;
localparam B = 3'b001;
localparam C = 3'b010;
localparam D = 3'b011;
localparam E = 3'b100;
localparam F = 3'b101;

// Sequential logic
always @(posedge clk) begin
    if (reset) begin
        state <= A;
        z_reg <= 1'b0;
    end else begin
        state <= next_state;
        // Output logic
        case (state)
            A: z_reg <= 1'b0;
            B: z_reg <= 1'b0;
            C: z_reg <= 1'b0;
            D: z_reg <= 1'b0;
            E: z_reg <= 1'b1;
            F: z_reg <= 1'b1;
            default: z_reg <= 1'b0;
        endcase
    end
end

// Combinational logic
always @(*) begin
    case (state)
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
        default: next_state = A;
    endcase
end

// Output assignment
assign z = z_reg;

endmodule