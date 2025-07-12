module comparator_4bit(
    input  [3:0] A,
    input  [3:0] B,
    output reg        A_greater,
    output reg        A_equal,
    output reg        A_less
);

    // Using a hierarchical approach
    reg [1:0] msb_A, msb_B, lsb_A, lsb_B;
    assign msb_A = A[3:2];
    assign msb_B = B[3:2];
    assign lsb_A = A[1:0];
    assign lsb_B = B[1:0];

    // Assigning A_equal first
    assign A_equal = (A == B);

    // Using logical operations to determine A_greater and A_less
    always @(*)
    begin
        if (msb_A > msb_B) begin
            A_greater = 1;
            A_less = 0;
        end else if (msb_A < msb_B) begin
            A_greater = 0;
            A_less = 1;
        end else begin
            if (lsb_A > lsb_B) begin
                A_greater = 1;
                A_less = 0;
            end else if (lsb_A < lsb_B) begin
                A_greater = 0;
                A_less = 1;
            end else begin
                A_greater = 0;
                A_less = 0;
            end
        end
    end

    // Alternative implementation using subtraction
    // reg [4:0] diff;
    // assign diff = {1'b0, A} - {1'b0, B};
    // assign A_greater = diff[4] == 0 && diff[3:0]!= 0;
    // assign A_equal = diff == 0;
    // assign A_less = diff[4] == 1;

endmodule