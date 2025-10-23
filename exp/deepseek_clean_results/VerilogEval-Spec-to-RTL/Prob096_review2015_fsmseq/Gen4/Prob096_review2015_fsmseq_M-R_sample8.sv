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

    reg [4:0] state;

    // State transitions as continuous assignments
    wire next_IDLE  = reset ? 1'b1 : 
                     (state == IDLE  && !data) || 
                     (state == S1    && !data) || 
                     (state == S3    && !data);

    wire next_S1    = (state == IDLE && data) || 
                     (state == S1    && !data);

    wire next_S2    = (state == S1    && data) || 
                     (state == S2    && data);

    wire next_S3    = (state == S2    && !data);

    wire next_FOUND = (state == S3    && data) || 
                     (state == FOUND);

    // State register
    always @(posedge clk) begin
        if (reset) begin
            state <= IDLE;
        end else begin
            state <= {next_FOUND, next_S3, next_S2, next_S1, next_IDLE};
        end
    end

    // Output assignment
    assign start_shifting = state[4]; // FOUND state bit

endmodule