module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    // One-hot state encoding
    localparam IDLE  = 5'b00001;
    localparam S1    = 5'b00010;
    localparam S2    = 5'b00100;
    localparam S3    = 5'b01000;
    localparam FOUND = 5'b10000;

    reg [4:0] state, next_state;

    // Combinational next-state logic
    assign next_state = reset ? IDLE :
                       (state == IDLE)  ? (data ? S1 : IDLE) :
                       (state == S1)    ? (data ? S2 : IDLE) :
                       (state == S2)    ? (data ? S2 : S3) :
                       (state == S3)     ? (data ? FOUND : IDLE) :
                       (state == FOUND)  ? FOUND :
                       IDLE;  // Default case

    // Sequential state update
    always @(posedge clk) begin
        state <= next_state;
    end

    // Output logic
    assign start_shifting = (state == FOUND);

endmodule