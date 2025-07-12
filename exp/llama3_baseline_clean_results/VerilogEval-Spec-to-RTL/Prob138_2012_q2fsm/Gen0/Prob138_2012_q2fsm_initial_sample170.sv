module TopModule(clk, reset, w, z);
    input clk, reset, w;
    output z;
    reg [2:0] state, next_state;

    // Define state codes
    localparam A = 3'b000;
    localparam B = 3'b001;
    localparam C = 3'b010;
    localparam D = 3'b011;
    localparam E = 3'b100;
    localparam F = 3'b101;

    // State transition logic
    always @(*) begin
        case(state)
            A: next_state = w ? B : A;
            B: next_state = w ? C : D;
            C: next_state = w ? E : D;
            D: next_state = w ? F : A;
            E: next_state = w ? E : D;
            F: next_state = w ? C : D;
            default: next_state = A; // Handle invalid states
        endcase
    end

    // State flip-flops
    always @(posedge clk) begin
        if (reset) begin
            state <= A; // Synchronous reset
        end else begin
            state <= next_state;
        end
    end

    // Output logic
    assign z = (state == E && w) || (state == F && w);
endmodule