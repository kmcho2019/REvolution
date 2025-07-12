module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

// Define states
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b010;
parameter D = 3'b011;
parameter E = 3'b100;
parameter F = 3'b101;

// Current state register
reg [2:0] current_state;

// Initialize current state to A
initial current_state = A;

// Sequential logic
always @(posedge clk or posedge reset) begin
    if (reset) begin
        current_state <= A;
    end else begin
        case (current_state)
            A: begin
                if (~w) begin
                    current_state <= B;
                end else begin
                    current_state <= A;
                end
            end
            B: begin
                if (~w) begin
                    current_state <= C;
                end else begin
                    current_state <= D;
                end
            end
            C: begin
                if (~w) begin
                    current_state <= E;
                end else begin
                    current_state <= D;
                end
            end
            D: begin
                if (~w) begin
                    current_state <= F;
                end else begin
                    current_state <= A;
                end
            end
            E: begin
                if (w) begin
                    current_state <= E;
                end else begin
                    current_state <= D;
                end
            end
            F: begin
                if (w) begin
                    current_state <= F;
                end else begin
                    current_state <= C;
                end
            end
        endcase
    end
end

// Combinational logic for output z
always @(*) begin
    case (current_state)
        A: z = 0;
        B: z = 0;
        C: z = 0;
        D: z = 0;
        E: z = 1;
        F: z = 1;
        default: z = 0;
    endcase
end

endmodule