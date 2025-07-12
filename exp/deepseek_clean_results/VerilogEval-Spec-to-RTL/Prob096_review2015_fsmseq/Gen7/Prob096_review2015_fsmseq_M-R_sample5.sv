module TopModule (
    input clk,
    input reset,
    input data,
    output start_shifting
);

    // State encoding (explicit bits)
    localparam IDLE  = 3'b000;
    localparam S1    = 3'b001;
    localparam S2    = 3'b010;
    localparam S3    = 3'b011;
    localparam FOUND = 3'b100;

    reg [2:0] state;
    wire [2:0] next_state;

    // Next state logic using continuous assignments
    assign next_state[0] = (state == IDLE) ? data :               // S1 if data=1
                          (state == S1)   ? data :               // S2 if data=1
                          (state == S2)   ? ~data :              // S3 if data=0
                          (state == S3)   ? data :               // FOUND if data=1
                          1'b0;                                  // Default (FOUND stays)

    assign next_state[1] = (state == IDLE) ? 1'b0 :
                          (state == S1)   ? data :               // S2 if data=1
                          (state == S2)   ? data :               // S2 if data=1
                          (state == S3)   ? 1'b0 :
                          1'b0;

    assign next_state[2] = (state == IDLE) ? 1'b0 :
                          (state == S1)   ? 1'b0 :
                          (state == S2)   ? 1'b0 :
                          (state == S3)   ? data :               // FOUND if data=1
                          1'b1;                                 // Stay in FOUND

    // State register with synchronous reset
    always @(posedge clk) begin
        state <= reset ? IDLE : next_state;
    end

    // Output assignment remains the same
    assign start_shifting = (state == FOUND);

endmodule