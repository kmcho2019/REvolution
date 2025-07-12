module TopModule(
    input clk,
    input reset,
    input x,
    output reg z
);

    reg [2:0] state;
    wire [2:0] next_state;

    localparam S0 = 3'b000;
    localparam S1 = 3'b001;
    localparam S2 = 3'b010;
    localparam S3 = 3'b011;
    localparam S4 = 3'b100;

    // Next state combinational logic using assign
    assign next_state = (state == S0) ? (x ? S1 : S0) :
                        (state == S1) ? (x ? S4 : S1) :
                        (state == S2) ? (x ? S1 : S2) :
                        (state == S3) ? (x ? S2 : S1) :
                        (state == S4) ? (x ? S4 : S3) : S0;

    // Synchronous state and output update
    always @(posedge clk) begin
        if (reset) begin
            state <= S0;
            z <= 1'b0;
        end else begin
            state <= next_state;
            // Output z is 1 only in states S3 and S4, else 0
            z <= (next_state == S3) || (next_state == S4);
        end
    end

endmodule