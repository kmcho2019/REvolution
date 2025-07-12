module TopModule(
    input  clk,
    input  reset,
    input  w,
    output reg z
);

// Define the states
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b011;
parameter E = 3'b100;
parameter F = 3'b101;

// Define the current state and next state
reg [2:0] current_state;
reg [2:0] next_state;

// Sequential process
always @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= A;
        z <= 0; // Initialize z to 0 when reset is asserted
    end else begin
        current_state <= next_state;
        
        // Determine output z based on current state
        case (next_state)
            A: z <= 0;
            B: z <= 0;
            C: z <= 0;
            D: z <= 0;
            E: z <= 1;
            F: z <= 1;
            default: z <= 0;
        endcase
    end
end

// Combinational process
always @(*) begin
    case (current_state)
        A: begin
            if (w) begin
                next_state <= A;
            end else begin
                next_state <= B;
            end
        end
        B: begin
            if (w) begin
                next_state <= D;
            end else begin
                next_state <= C;
            end
        end
        C: begin
            if (w) begin
                next_state <= D;
            end else begin
                next_state <= E;
            end
        end
        D: begin
            if (w) begin
                next_state <= A;
            end else begin
                next_state <= F;
            end
        end
        E: begin
            if (w) begin
                next_state <= D;
            end else begin
                next_state <= E;
            end
        end
        F: begin
            if (w) begin
                next_state <= D;
            end else begin
                next_state <= C;
            end
        end
        default: begin
            next_state <= A;
        end
    endcase
end

endmodule