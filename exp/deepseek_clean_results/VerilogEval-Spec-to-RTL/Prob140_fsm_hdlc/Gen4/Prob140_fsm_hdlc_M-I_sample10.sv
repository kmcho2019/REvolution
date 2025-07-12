module TopModule (
    input clk,
    input reset,
    input in,
    output reg disc,
    output reg flag,
    output reg err
);

    reg [2:0] count;
    reg [2:0] next_count;
    wire count_plus_1 = count + 1;
    wire is_count_5 = (count == 3'd5);
    wire is_count_6 = (count == 3'd6);

    always @(posedge clk) begin
        if (reset) begin
            count <= 0;
            disc <= 0;
            flag <= 0;
            err <= 0;
        end else begin
            count <= next_count;
            
            // Output generation (registered)
            disc <= is_count_5 && !in;
            flag <= is_count_6 && !in;
            err <= (count >= 3'd6) && in;
        end
    end

    always @(*) begin
        // Counter update logic
        if (in) begin
            next_count = (count < 3'd7) ? count_plus_1 : count;
        end else begin
            next_count = 3'd0;
        end
    end

endmodule