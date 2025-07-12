module multi_8bit(
    input [7:0] A,
    input [7:0] B,
    output reg [15:0] product
);

    wire [15:0] shifted_A [0:7];  // All possible shifted versions of A
    
    // Generate all shifted versions in parallel
    assign shifted_A[0] = {8'd0, A};
    assign shifted_A[1] = {7'd0, A, 1'b0};
    assign shifted_A[2] = {6'd0, A, 2'b0};
    assign shifted_A[3] = {5'd0, A, 3'b0};
    assign shifted_A[4] = {4'd0, A, 4'b0};
    assign shifted_A[5] = {3'd0, A, 5'b0};
    assign shifted_A[6] = {2'd0, A, 6'b0};
    assign shifted_A[7] = {1'd0, A, 7'b0};

    always @(*) begin
        product = 16'd0;  // Initialize product
        
        // Parallel bit checking and accumulation
        if (B[0]) product = product + shifted_A[0];
        if (B[1]) product = product + shifted_A[1];
        if (B[2]) product = product + shifted_A[2];
        if (B[3]) product = product + shifted_A[3];
        if (B[4]) product = product + shifted_A[4];
        if (B[5]) product = product + shifted_A[5];
        if (B[6]) product = product + shifted_A[6];
        if (B[7]) product = product + shifted_A[7];
    end

endmodule