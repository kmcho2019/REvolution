module TopModule (
    input  wire        clk,
    input  wire        areset,
    input  wire [7:0]  d,
    output reg  [7:0]  q
);

    // Implement each DFF with async active-high reset individually
    always @(posedge clk or posedge areset) begin
        if (areset)
            q[0] <= 1'b0;
        else
            q[0] <= d[0];
    end

    always @(posedge clk or posedge areset) begin
        if (areset)
            q[1] <= 1'b0;
        else
            q[1] <= d[1];
    end

    always @(posedge clk or posedge areset) begin
        if (areset)
            q[2] <= 1'b0;
        else
            q[2] <= d[2];
    end

    always @(posedge clk or posedge areset) begin
        if (areset)
            q[3] <= 1'b0;
        else
            q[3] <= d[3];
    end

    always @(posedge clk or posedge areset) begin
        if (areset)
            q[4] <= 1'b0;
        else
            q[4] <= d[4];
    end

    always @(posedge clk or posedge areset) begin
        if (areset)
            q[5] <= 1'b0;
        else
            q[5] <= d[5];
    end

    always @(posedge clk or posedge areset) begin
        if (areset)
            q[6] <= 1'b0;
        else
            q[6] <= d[6];
    end

    always @(posedge clk or posedge areset) begin
        if (areset)
            q[7] <= 1'b0;
        else
            q[7] <= d[7];
    end

endmodule