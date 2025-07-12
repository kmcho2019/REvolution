module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    reg [2:0] count;
    reg [2:0] count_gray; // Gray-coded version for power optimization
    wire count5, count6, count7;

    // Gray code conversion
    always @(*) begin
        case(count)
            3'd0: count_gray = 3'b000;
            3'd1: count_gray = 3'b001;
            3'd2: count_gray = 3'b011;
            3'd3: count_gray = 3'b010;
            3'd4: count_gray = 3'b110;
            3'd5: count_gray = 3'b111;
            3'd6: count_gray = 3'b101;
            3'd7: count_gray = 3'b100;
        endcase
    end

    // Pre-compute critical conditions
    assign count5 = (count == 3'd5);
    assign count6 = (count == 3'd6);
    assign count7 = (count == 3'd7);

    always @(posedge clk) begin
        if (reset) begin
            count <= 0;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            // Update counter with saturation at 7
            if (in) begin
                if (!count7) count <= count + 1;
            end else begin
                count <= 0;
            end

            // Clear outputs only when they might be set
            if (in && count6) err <= 1;
            else if (!in) err <= 0;

            if (!in) begin
                disc <= count5;
                flag <= count6;
            end else begin
                // Only clear disc/flag when needed
                if (count5 || count6) begin
                    disc <= 0;
                    flag <= 0;
                end
            end
        end
    end

endmodule