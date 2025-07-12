module TopModule (
    input clk,
    input reset,
    input s,
    input w,
    output z
);

    // Combined state and count register
    reg [1:0] state_count;
    localparam A = 2'b00;
    localparam B0 = 2'b01;  // B state, cycle 0
    localparam B1 = 2'b10;  // B state, cycle 1
    localparam B2 = 2'b11;  // B state, cycle 2

    // Output logic - set z when we've seen exactly two 1's in last 3 cycles
    assign z = (state_count == B0) && (w == 0);

    // Sequential logic
    always @(posedge clk) begin
        if (reset) begin
            state_count <= A;
        end else begin
            case (state_count)
                A: state_count <= s ? B0 : A;
                B0: state_count <= w ? B1 : B0;
                B1: state_count <= w ? B2 : B1;
                B2: state_count <= B0;
            endcase
        end
    end

endmodule