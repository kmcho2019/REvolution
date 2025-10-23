module TopModule(
    input clk,
    input reset,
    input w,
    output reg z
);

// Define the states using gray code encoding
parameter A = 3'b000;
parameter B = 3'b001;
parameter C = 3'b011;
parameter D = 3'b010;
parameter E = 3'b110;
parameter F = 3'b111;

// State register
reg [2:0] currentState;

// Combinational logic for next state and output z
always @(posedge clk) begin
    if (reset) begin
        currentState <= A;
        z <= 0;
    end else begin
        case (currentState)
            A: begin
                currentState <= w? A : B;
                z <= 0;
            end
            B: begin
                currentState <= w? D : C;
                z <= 0;
            end
            C: begin
                currentState <= w? D : E;
                z <= 0;
            end
            D: begin
                currentState <= w? A : F;
                z <= 0;
            end
            E: begin
                currentState <= w? D : E;
                z <= 1;
            end
            F: begin
                currentState <= w? D : C;
                z <= 1;
            end
            default: begin
                currentState <= A;
                z <= 0;
            end
        endcase
    end
end

endmodule