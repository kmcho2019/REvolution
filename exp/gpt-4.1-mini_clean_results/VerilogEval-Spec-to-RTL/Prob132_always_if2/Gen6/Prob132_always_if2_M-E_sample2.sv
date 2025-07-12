module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    always @(*) begin
        if (cpu_overheated) begin
            shut_off_computer = 1'b1;
        end else begin
            shut_off_computer = 1'b0;
        end

        if (~arrived) begin
            if (gas_tank_empty)
                keep_driving = 1'b0;
            else
                keep_driving = 1'b1;
        end else begin
            keep_driving = 1'b0;
        end
    end

endmodule