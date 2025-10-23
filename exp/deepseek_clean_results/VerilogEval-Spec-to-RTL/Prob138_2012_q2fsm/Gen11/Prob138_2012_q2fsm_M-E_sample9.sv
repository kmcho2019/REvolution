module TopModule (
    input clk,
    input reset,
    input w,
    output reg z
);

    // Hybrid state encoding
    parameter [2:0] 
        A = 3'b000,  // 2-bit binary part
        B = 3'b001,
        C = 3'b010,
        D = 3'b011,
        E = 3'b100,  // One-hot part
        F = 3'b101;

    reg [2:0] state, next_state;
    reg next_z;

    // State transition logic with output prediction
    always @(*) begin
        case (state)
            A: begin
                next_state = w ? B : A;
                next_z = 1'b0;
            end
            B: begin
                next_state = w ? C : D;
                next_z = 1'b0;
            end
            C: begin
                next_state = w ? E : D;
                next_z = w ? 1'b1 : 1'b0;
            end
            D: begin
                next_state = w ? F : A;
                next_z = w ? 1'b1 : 1'b0;
            end
            E: begin
                next_state = w ? E : D;
                next_z = 1'b1;
            end
            F: begin
                next_state = w ? C : D;
                next_z = 1'b1;
            end
            default: begin
                next_state = A;
                next_z = 1'b0;
            end
        endcase
    end

    // Sequential logic with early reset
    always @(posedge clk) begin
        if (reset) begin
            state <= A;
            z <= 1'b0;
        end else begin
            state <= next_state;
            z <= next_z;
        end
    end

endmodule