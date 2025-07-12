module div_16bit (
    input [15:0] A,
    input [7:0] B,
    output [15:0] result,
    output [15:0] odd
);

    // Constants and type definitions
    localparam STAGES = 8;
    wire [7:0] divisor = B;
    wire [7:0] divisor_2 = {B[6:0], 1'b0};
    wire [7:0] divisor_neg = ~B + 1;
    wire [7:0] divisor_neg_2 = ~divisor_2 + 1;

    // Stage registers
    reg [8:0] rem [0:STAGES];  // 1 extra bit for sign
    reg [1:0] q [0:STAGES-1];
    reg [15:0] quotient;

    // Initialize first stage
    always @(*) begin
        rem[0] = {1'b0, A[15:8]};  // Upper 8 bits of dividend
    end

    // Parallel prefix stages
    genvar i;
    generate
        for (i = 0; i < STAGES; i = i + 1) begin : stage
            // Quotient digit selection (-1, 0, +1)
            wire [2:0] rem_trunc = rem[i][8:6];  // 3 MSBs for selection
            
            always @(*) begin
                casez (rem_trunc)
                    3'b000: q[i] = 2'b00;  // 0
                    3'b001: q[i] = 2'b00;  // 0
                    3'b010: q[i] = 2'b01;  // +1
                    3'b011: q[i] = 2'b01;  // +1
                    3'b100: q[i] = 2'b11;  // -1
                    3'b101: q[i] = 2'b11;  // -1
                    3'b110: q[i] = 2'b00;  // 0
                    3'b111: q[i] = 2'b00;  // 0
                endcase
            end

            // Remainder computation
            wire [7:0] next_rem_partial;
            always @(*) begin
                case (q[i])
                    2'b01: next_rem_partial = rem[i][7:0] - divisor;
                    2'b11: next_rem_partial = rem[i][7:0] + divisor;
                    default: next_rem_partial = rem[i][7:0];
                endcase
                
                if (i < STAGES-1) begin
                    rem[i+1] = {next_rem_partial[7], 
                               {next_rem_partial[6:0], A[7-i*2 -: 2]}};
                end else begin
                    rem[i+1] = {next_rem_partial[7], next_rem_partial};
                end
            end
        end
    endgenerate

    // Convert signed-digit quotient to binary
    always @(*) begin
        quotient = 16'b0;
        for (integer j = 0; j < STAGES; j = j + 1) begin
            quotient[15-j*2 -: 2] = q[j][1] ? (q[j][0] ? 2'b11 : 2'b01) : 2'b00;
        end
    end

    // Final outputs
    assign result = quotient;
    assign odd = {8'b0, rem[STAGES][7:0]};

endmodule