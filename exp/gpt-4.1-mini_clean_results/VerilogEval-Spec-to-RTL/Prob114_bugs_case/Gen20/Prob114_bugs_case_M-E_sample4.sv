module TopModule(
    input  [7:0] code,
    output reg [3:0] out,
    output reg valid
);

    // Known scancodes
    localparam [7:0] C0 = 8'h45;
    localparam [7:0] C1 = 8'h16;
    localparam [7:0] C2 = 8'h1E;
    localparam [7:0] C3 = 8'h26;
    localparam [7:0] C4 = 8'h25;
    localparam [7:0] C5 = 8'h2E;
    localparam [7:0] C6 = 8'h36;
    localparam [7:0] C7 = 8'h3D;
    localparam [7:0] C8 = 8'h3E;
    localparam [7:0] C9 = 8'h46;

    always @(*) begin
        valid = 1'b0;
        out = 4'd0;
        if (code == C0) begin
            out = 4'd0;
            valid = 1'b1;
        end else if (code == C1) begin
            out = 4'd1;
            valid = 1'b1;
        end else if (code == C2) begin
            out = 4'd2;
            valid = 1'b1;
        end else if (code == C3) begin
            out = 4'd3;
            valid = 1'b1;
        end else if (code == C4) begin
            out = 4'd4;
            valid = 1'b1;
        end else if (code == C5) begin
            out = 4'd5;
            valid = 1'b1;
        end else if (code == C6) begin
            out = 4'd6;
            valid = 1'b1;
        end else if (code == C7) begin
            out = 4'd7;
            valid = 1'b1;
        end else if (code == C8) begin
            out = 4'd8;
            valid = 1'b1;
        end else if (code == C9) begin
            out = 4'd9;
            valid = 1'b1;
        end
    end

endmodule