module TopModule (
    input             clk,
    input             rst_n,
    input             cpu_overheated,
    output reg        shut_off_computer,
    input             arrived,
    input             gas_tank_empty,
    output reg        keep_driving
);

    // Combinational internal signals
    wire shut_off_comb;
    wire keep_drive_comb;

    assign shut_off_comb   = cpu_overheated;
    assign keep_drive_comb = ~arrived & ~gas_tank_empty;

    // Sequential logic to update outputs synchronously with reset
    always @(posedge clk or negedge rst_n) begin
        if (!rst_n) begin
            shut_off_computer <= 1'b0;
            keep_driving      <= 1'b0;
        end else begin
            shut_off_computer <= shut_off_comb;
            keep_driving      <= keep_drive_comb;
        end
    end

endmodule