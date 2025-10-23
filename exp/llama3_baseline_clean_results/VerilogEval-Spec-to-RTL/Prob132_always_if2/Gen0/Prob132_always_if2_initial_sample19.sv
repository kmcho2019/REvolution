module TopModule (
    input      cpu_overheated,
    output reg shut_off_computer,
    input      arrived,
    input      gas_tank_empty,
    output reg keep_driving
);

    always @(*) begin
        if (cpu_overheated) begin
            shut_off_computer = 1;
            keep_driving = 0; // prioritize shutting off the computer
        end else begin
            shut_off_computer = 0;
            if (~arrived) begin
                keep_driving = ~gas_tank_empty;
            end else begin
                keep_driving = 0; // stop driving when arrived
            end
        end
    end

endmodule