module TopModule(
    input  logic [4:0] a,
    input  logic [4:0] b,
    input  logic [4:0] c,
    input  logic [4:0] d,
    input  logic [4:0] e,
    input  logic [4:0] f,
    output logic [7:0] w,
    output logic [7:0] x,
    output logic [7:0] y,
    output logic [7:0] z,
    input  logic clk, // Clock for state machine
    input  logic rst_n // Reset, active low
);

    logic [2:0] state; // 3 bits can represent 8 states (0 to 7)
    logic [31:0] output_vector;
    logic [1:0] final_bits;

    always_ff @(posedge clk or negedge rst_n) begin
        if (~rst_n) begin
            state <= 0;
            output_vector <= 32'd0;
            final_bits <= 2'b00;
        end else begin
            case (state)
                3'd0: begin
                    output_vector[31:26] <= a;
                    state <= 3'd1;
                end
                3'd1: begin
                    output_vector[25:20] <= b;
                    state <= 3'd2;
                end
                3'd2: begin
                    output_vector[19:14] <= c;
                    state <= 3'd3;
                end
                3'd3: begin
                    output_vector[13:8] <= d;
                    state <= 3'd4;
                end
                3'd4: begin
                    output_vector[7:2] <= e;
                    state <= 3'd5;
                end
                3'd5: begin
                    output_vector[1:0] <= f[1:0];
                    final_bits <= f[3:2];
                    state <= 3'd6;
                end
                3'd6: begin
                    output_vector[1:0] <= {final_bits, 1'b1};
                    state <= 3'd7;
                end
                3'd7: begin
                    output_vector[1:0] <= 2'b11;
                    state <= 3'd0; // Reset state
                end
                default: state <= 3'd0;
            endcase
        end
    end

    assign w = output_vector[31:24];
    assign x = output_vector[23:16];
    assign y = output_vector[15:8];
    assign z = output_vector[7:0];

endmodule