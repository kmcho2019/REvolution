module multi_16bit (
    input  logic            clk,
    input  logic            rst_n,
    input  logic            start,
    input  logic [15:0]     ain,
    input  logic [15:0]     bin,
    output logic [31:0]     yout,
    output logic            done
);

    logic [15:0] areg;
    logic [15:0] breg;
    logic [31:0] yout_r;
    logic [4:0]  i;
    logic        done_r;

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            i <= 5'd0;
        end else if (start) begin
            if (i < 5'd17) begin
                i <= i + 1;
            end else begin
                i <= i;
            end
        end else begin
            i <= 5'd0;
        end
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            done_r <= 1'b0;
        end else if (i == 5'd16) begin
            done_r <= 1'b1;
        end else if (i == 5'd17) begin
            done_r <= 1'b0;
        end else begin
            done_r <= done_r;
        end
    end

    always_ff @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            areg <= 16'd0;
            breg <= 16'd0;
            yout_r <= 32'd0;
        end else if (start) begin
            if (i == 5'd0) begin
                areg <= ain;
                breg <= bin;
            end else if (i < 5'd17) begin
                if (areg[i-1] == 1'b1) begin
                    yout_r <= yout_r + (breg << (i-1));
                end
            end
        end else begin
            areg <= 16'd0;
            breg <= 16'd0;
            yout_r <= 32'd0;
        end
    end

    assign yout = yout_r;
    assign done = done_r;

endmodule