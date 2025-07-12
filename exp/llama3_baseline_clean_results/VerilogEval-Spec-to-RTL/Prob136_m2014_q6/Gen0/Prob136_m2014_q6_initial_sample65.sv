module TopModule(
    input clk,
    input reset,
    input w,
    output z
);

reg [2:0] state; // Current state
reg [2:0] nextState; // Next state

// Define states
localparam A = 3'b000;
localparam B = 3'b001;
localparam C = 3'b010;
localparam D = 3'b011;
localparam E = 3'b100;
localparam F = 3'b101;

// Output z based on the current state
always @(state) begin
    case(state)
        A: z = 0;
        B: z = 0;
        C: z = 0;
        D: z = 0;
        E: z = 1;
        F: z = 1;
        default: z = 0;
    endcase
end

// State transitions
always @(posedge clk or posedge reset) begin
    if(reset) begin
        state <= A;
    end else begin
        case(state)
            A: begin
                if(w) begin
                    state <= A;
                end else begin
                    state <= B;
                end
            end
            B: begin
                if(w) begin
                    state <= D;
                end else begin
                    state <= C;
                end
            end
            C: begin
                if(w) begin
                    state <= D;
                end else begin
                    state <= E;
                end
            end
            D: begin
                if(w) begin
                    state <= A;
                end else begin
                    state <= F;
                end
            end
            E: begin
                if(w) begin
                    state <= D;
                end else begin
                    state <= E;
                end
            end
            F: begin
                if(w) begin
                    state <= D;
                end else begin
                    state <= C;
                end
            end
            default: state <= A;
        endcase
    end
end

endmodule