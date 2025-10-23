module TopModule(
    output out
);
    reg drive_value;
    initial drive_value = 1'b0;
    assign out = drive_value;
endmodule