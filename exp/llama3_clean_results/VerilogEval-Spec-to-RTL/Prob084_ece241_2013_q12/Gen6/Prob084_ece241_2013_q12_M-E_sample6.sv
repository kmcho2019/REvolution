module TopModule(
    input clk,
    input enable,
    input S,
    input A,
    input B,
    input C,
    output reg Z
);

    reg [7:0] Q;

    // Demultiplexers to select the input for each flip-flop
    always @(posedge clk) begin
        if (enable) begin
            if ({A, B, C} == 3'b000) begin
                Q[0] <= S;
            end else if ({A, B, C} == 3'b001) begin
                Q[1] <= S;
            end else if ({A, B, C} == 3'b010) begin
                Q[2] <= S;
            end else if ({A, B, C} == 3'b011) begin
                Q[3] <= S;
            end else if ({A, B, C} == 3'b100) begin
                Q[4] <= S;
            end else if ({A, B, C} == 3'b101) begin
                Q[5] <= S;
            end else if ({A, B, C} == 3'b110) begin
                Q[6] <= S;
            end else if ({A, B, C} == 3'b111) begin
                Q[7] <= S;
            end
        end
    end

    // Multiplexer to select the output
    always @(posedge clk) begin
        if (enable) begin
            case ({A, B, C})
                3'b000: Z <= Q[0];
                3'b001: Z <= Q[1];
                3'b010: Z <= Q[2];
                3'b011: Z <= Q[3];
                3'b100: Z <= Q[4];
                3'b101: Z <= Q[5];
                3'b110: Z <= Q[6];
                3'b111: Z <= Q[7];
            endcase
        end
    end

endmodule

module testbench;
    reg clk;
    reg enable;
    reg S;
    reg A;
    reg B;
    reg C;
    wire Z;

    TopModule uut(
        .clk(clk),
        .enable(enable),
        .S(S),
        .A(A),
        .B(B),
        .C(C),
        .Z(Z)
    );

    initial begin
        $dumpfile("dump.vcd");
        $dumpvars;
        clk = 0;
        enable = 0;
        S = 0;
        A = 0;
        B = 0;
        C = 0;
        #100;
        $finish;
    end

    always #5 clk = ~clk;

    initial begin
        #10;
        enable = 1'b1;
        S = 1'b1;
        #10;
        A = 1'b1;
        #10;
        B = 1'b1;
        #10;
        C = 1'b1;
        #10;
        S = 1'b0;
        #10;
        A = 1'b0;
        #10;
        B = 1'b0;
        #10;
        C = 1'b0;
    end

    initial begin
        #5;
        $display("Z: %b", Z);
        #10;
        $display("Z: %b", Z);
        #10;
        $display("Z: %b", Z);
        #10;
        $display("Z: %b", Z);
        #10;
        $display("Z: %b", Z);
    end
endmodule