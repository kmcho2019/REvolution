module multi_16bit (
    input  logic clk,
    input  logic rst_n,
    input  logic start,
    input  logic [15:0] ain,
    input  logic [15:0] bin,
    output logic [31:0] yout,
    output logic done
);

logic [31:0] yout_r;
logic [15:0] areg;
logic [15:0] breg;
logic [4:0] i;
logic done_r;

always_ff @(posedge clk or negedge rst_n) begin
    if (~rst_n) begin
        i <= 0;
        done_r <= 0;
        areg <= 0;
        breg <= 0;
        yout_r <= 0;
    end else begin
        if (start) begin
            if (i < 16) begin
                i <= i + 1;
            end else if (i == 16) begin
                i <= i + 1;
                done_r <= 1;
            end else if (i == 17) begin
                i <= 0;
                done_r <= 0;
            end
            if (i == 0) begin
                areg <= ain;
                breg <= bin;
            end else if (areg[i-1] == 1'b1) begin
                yout_r <= yout_r + (breg << (i-1));
            end
        end else begin
            i <= 0;
            areg <= 0;
            breg <= 0;
            yout_r <= 0;
            done_r <= 0;
        end
    end
end

assign yout = yout_r;
assign done = done_r;

endmodule