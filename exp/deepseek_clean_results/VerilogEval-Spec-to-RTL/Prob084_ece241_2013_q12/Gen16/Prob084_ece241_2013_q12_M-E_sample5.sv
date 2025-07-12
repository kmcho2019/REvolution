module FlexibleShiftRegister (
    input clk,
    input enable,
    input mode,  // 0=shift, 1=parallel load
    input clear,
    input S,
    input [7:0] parallel_in,
    output reg [7:0] Q
);
    always @(posedge clk) begin
        if (clear) begin
            Q <= 8'b0;
        end else if (enable) begin
            if (mode) begin
                Q <= parallel_in;  // Parallel load
            end else begin
                Q <= {Q[6:0], S};  // Shift operation
            end
        end
    end
endmodule

module TopModule (
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output Z
);
    wire [7:0] Q;
    wire [2:0] sel = {A, B, C};
    wire [7:0] decoder_out;
    wire [7:0] and_out;

    // Instantiate the enhanced shift register
    FlexibleShiftRegister sr_inst (
        .clk(clk),
        .enable(enable),
        .mode(1'b0),  // Always in shift mode for this application
        .clear(1'b0),  // Not used in this application
        .S(S),
        .parallel_in(8'b0),  // Not used in shift mode
        .Q(Q)
    );

    // Decoder-based mux implementation
    assign decoder_out = (sel == 3'b000) ? 8'b00000001 :
                        (sel == 3'b001) ? 8'b00000010 :
                        (sel == 3'b010) ? 8'b00000100 :
                        (sel == 3'b011) ? 8'b00001000 :
                        (sel == 3'b100) ? 8'b00010000 :
                        (sel == 3'b101) ? 8'b00100000 :
                        (sel == 3'b110) ? 8'b01000000 :
                        8'b10000000;

    assign and_out = Q & decoder_out;
    assign Z = |and_out;  // OR reduction of AND outputs
endmodule